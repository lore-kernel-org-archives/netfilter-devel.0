From: John Lange <john.lange@bighostbox.com>
Subject: Re: --log-uid target?
Date: Wed, 03 Nov 2004 20:31:57 -0600
Message-ID: <1099535517.26577.586.camel@ws102.darkcore.net>
References: <1099109256.1798.411.camel@ws102.darkcore.net>
	<41898F60.8080004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41898F60.8080004@trash.net>
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

Actually, Martin supplied me with the old patch from 2002 which I
modified to work with 2.6.9 and I sent them back to him for review.

I have been using it on 2 production systems since The weekend and so
far everything seems good.

There is one problem though, though I have this line in my firewall
script:

/usr/local/sbin/iptables -A OUTPUT -p tcp --dport 25 -j LOG --log-prefix
"SMTP " --log-uid

A great deal of packets are being logged with NO UID as follows:

Nov  3 20:16:50 venus kernel: SMTP IN= OUT=eth0 SRC=209.xxx.xxx.xxx
DST=203.xxx.xxx.xxx LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=8368 DF
PROTO=TCP SPT=39737 DPT=25 WINDOW=0 RES=0x00 RST URGP=0

The target does in fact work at least some of the time because there are
also plenty of packets logged like this:

Nov  3 20:25:45 venus kernel: SMTP IN= OUT=eth0 SRC=209.xxx.xxx.xxx
DST=64..xxx.xxx.xxx LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=7784 DF
PROTO=TCP SPT=39780 DPT=25 WINDOW=1460 RES=0x00 ACK URGP=0 UID=500 

UID=500 is what i expect since thats my SMTP server uid.

Under what situations could an outgoing packet be logged without a UID?
Something must own this packet?

The reason I need this patch is because I'm concerned someone might be
operating a spam relay on their account but I have no way of figuring
out who. I was hoping this would help me track it down.

Regards,
-- 
John Lange


On Wed, 2004-11-03 at 20:09, Patrick McHardy wrote:
> John Lange wrote:
> 
> >Way back in the archives from 2002 I see a patch to add support for
> >logging of the userid.
> >
> >Searching high and low and can't find any other reference to this
> >feature and it does not appear to be in the current iptables or
> >patch-o-matic downloads.
> >
> >Did this ever get implemented? How do you use it?
> >
> Just Martin's patch from 2002.
> 
> >
> >I tried -j LOG --log-uid but it gives an error.
> >
> >I'm blocking out-bound packets to port 25 to prevent local users from
> >spamming. However, I'd like to who it is that is attempting to spam and
> >also be able to watch the logs to make sure legitimate processes are
> >able to send mail.
> >
> Sounds like a useful addition. Martin, any reason why this patch was
> never merged ?
> 
> Regards
> Patrick
