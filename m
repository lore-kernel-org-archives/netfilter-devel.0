From: "Grace Li" <zheyinli@hotmail.com>
Subject: Information missing in new thread after REDIRECT of iptables
Date: Fri, 16 Apr 2004 15:43:29 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY7-F58VqeavxhgueN00053f34@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: zheyinli@hotmail.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bazsi@balabit.hu, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Thanks for the hint on establishing multiple connections.  Now I am able to 
handle packets targeted for different ports when they all directed to the 
same local port.  A new problem occurs when I pass the file descriptor 
(fd=accept(server_socket, (struct sockaddr *)&server_ssin, &len)) got from 
the socket connect function to a new thread, and when I try to read the 
destination addr and port from this descriptor  (getsockopt (fd, SOL_IP, 
SO_ORIGINAL_DST, (struct sockaddr*)&addr, &len_t );) .  The result I got is:
Original Destination IP  is  0.0.0.0
Destination Port is 0

Any idea? I am still able to read correct data from this file descriptor, 
just getsockopt does not work, the error returned was "Invalid argument".

Thanks,

Grace


>From: Balazs Scheidler <bazsi@balabit.hu>
>To: Grace Li <zheyinli@hotmail.com>
>Subject: Re: How to get original destination port after REDIRECT 
>ofiptables?
>Date: Thu, 15 Apr 2004 09:51:23 +0200
>
>2004-04-14, sze keltezéssel 23:17-kor Grace Li ezt írta:
> > Hi folks,
> >
> > I have know that using REDIRECT option of iptables could redirect 
>traffic to
> > a specified remote port to another local port, for example iptables -t 
>nat
> > -A PREROUTING -i eth0 -p tcp --dport 1888 -j REDIRECT --to-port 2000 .  
>The
> > original destination IP address is not changed, and could be obtained 
>from
> > getsockopt call with specifiying SO_ORIGINAL_DST ( e.g. getsockopt 
>(client,
> > SOL_IP, SO_ORIGINAL_DST, (struct sockaddr*)&addr, &len_t );) .
> >
> > What I want to do is that for every incoming packets to ether net 
>interface,
> > I want to direct to one spcific port, instead of dedirecting traffic 
>from
> > one port to another port. In another words, I want to do multi-port 
>match
> > one port instead of one to one port match.  Could anybody suggest if it 
>is
> > doable? If yes, how could the application that listens to the 
>re-directed
> > port knows the original destination port?
>
>Conntrack differentiates between multiple connections based on the peer
>address/port. As this needs to be specified to the SO_ORIGINAL_DST
>lookup there's no problem in finding out both the original address and
>port.
>
>--
>Bazsi
>PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 
>8EB1
>
>

_________________________________________________________________
MSN Premium with Virus Guard and Firewall* from McAfee® Security : 2 months 
FREE*   
http://join.msn.com/?pgmarket=en-ca&page=byoa/prem&xAPID=1994&DI=1034&SU=http://hotmail.com/enca&HL=Market_MSNIS_Taglines
