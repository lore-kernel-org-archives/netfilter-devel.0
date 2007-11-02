From: Larry Auton <netfilter@winux.com>
Subject: TCP connections that use NAT silently time out
Date: Fri, 02 Nov 2007 15:40:52 -0400
Message-ID: <472B7D44.8000200@winux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gs-202.guidescope.com ([64.21.61.202]:55483 "EHLO winux.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758068AbXKBUUO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 16:20:14 -0400
Received: from [127.0.0.1] (helo=[192.168.135.200])
	by winux.com with esmtpa (Exim 4.60)
	(envelope-from <netfilter@winux.com>)
	id 1Io2Nx-0001kn-9C
	for netfilter-devel@vger.kernel.org; Fri, 02 Nov 2007 15:40:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

See http://www.winux.com/hc/ for the sample programs.  The entire 
package is in hc.tgz

TCP connections that use NAT silently time out after 60 seconds if one
of the peers shutsdown its write-side of the connection.  This sequence
illustrates the problem.

c.1             fd = socket(...)
c.2             connect(... fd ...)
        s.1                             fd = accept(...)
c.3             write(...)
        s.2                             read(...)
c.4             shutdown(fd, SHUT_WR)
c.5             read(...)
        s.3                             sleep(65)
        s.4                             write(....)

If the client is on one side of a NAT connection and the server is
on the other side, then Step c.5 NEVER COMPLETES.  It will simpy hang.

Packet sniffing shows that the NAT host sends RST responses to
the "outside" server machine when it sends the data to the client
at step s.4.

After the ACK in response to the client's write (step c.3) is forwarded 
to the client,
no more packets are sent from the NAT machine to the client.

The URL above provides two simple C programs that illustrate the problem.

on the "outside" server (say 192.168.136.7)

        $ hc-server

on the "inside" client machine

        $ hc-client 192.168.136.7 9999 1 65

        the arguments are:

        x.x.x.x = IP address of the "outside" server
           9999 = server port number
              1 = whether or not to do the half-close
             65 = seconds of delay before the server responds

It will complete normally if any of the following are true:

        use delay of less than 60 seconds
        don't use the half-close (set to next to last argument to 0)
        server is NOT on the far side of a NAT connection

Otherwise, the client will hang until a SIGALRM wakes it 15 seconds after
the delay period has elapsed.

