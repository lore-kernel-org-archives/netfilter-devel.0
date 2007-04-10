From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netlink error datagrams
Date: Tue, 10 Apr 2007 09:57:04 +0200
Message-ID: <461B4350.3000102@trash.net>
References: <20070410040840.GA23429@kallisti.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Ross Vandegrift <ross@kallisti.us>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070410040840.GA23429@kallisti.us>
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

Ross Vandegrift wrote:
> Hello everyone,
> 
> I have a libipq application that I'm using with netfilter.  I have the
> following fragment of code, mostly from the FAQ:
> 
>       status = ipq_read(h, buf, BUFSIZE, 0);
>       if (status < 0)
> 	rr_err ("%s", ipq_errstr ());
>       
>       switch (ipq_message_type(buf))
> 	{
> 	case IPQM_PACKET:
>           /* Do stuff with the packet */
>           break;
> 
> 	case NLMSG_ERROR:
>           ipq_perror ("rrfilter");
> 
> 
> In my production boxes, I'm hitting the NLMSG_ERROR case pretty
> frequently - as often as every minute.  It doesn't seem to adversely
> affect packet processing, but I'm not sure because I can only
> reproduce it with real traffic.
> 
> I've attached via gdb and the netlink messages I'm getting are just a
> header and the four bytes of padding.  ipq_perror reports "Unknown
> failure".


What error code does the header contain?
