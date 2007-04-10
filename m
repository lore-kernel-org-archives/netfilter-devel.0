From: Ross Vandegrift <ross@kallisti.us>
Subject: Netlink error datagrams
Date: Tue, 10 Apr 2007 00:08:40 -0400
Message-ID: <20070410040840.GA23429@kallisti.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello everyone,

I have a libipq application that I'm using with netfilter.  I have the
following fragment of code, mostly from the FAQ:

      status = ipq_read(h, buf, BUFSIZE, 0);
      if (status < 0)
	rr_err ("%s", ipq_errstr ());
      
      switch (ipq_message_type(buf))
	{
	case IPQM_PACKET:
          /* Do stuff with the packet */
          break;

	case NLMSG_ERROR:
          ipq_perror ("rrfilter");


In my production boxes, I'm hitting the NLMSG_ERROR case pretty
frequently - as often as every minute.  It doesn't seem to adversely
affect packet processing, but I'm not sure because I can only
reproduce it with real traffic.

I've attached via gdb and the netlink messages I'm getting are just a
header and the four bytes of padding.  ipq_perror reports "Unknown
failure".

Any hints as to what's causing me to receive these netlink messages?
How can I figure out what's gone wrong and if it's worth worrying
about?

Thanks in advance!

-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
