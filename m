From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: change in behavior of OUTPUT chain rule in 2.6.19
Date: Thu, 31 May 2007 23:01:59 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705312300490.11140@yvahk01.tjqt.qr>
References: <13313.1180642185@mdt.dhcp.pit.laurelnetworks.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Mike Accetta <maccetta@laurelnetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <13313.1180642185@mdt.dhcp.pit.laurelnetworks.com>
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


On May 31 2007 16:09, Mike Accetta wrote:
>> >
>> > iptables -A  OUTPUT -p tcp --destination-port 23 \
>> > --destination 10.0.20.1  -j REJECT --reject-with tcp-reset
>> 
>> I cannot reproduce this with 2.6.20.2. Have you tried any newer kernel?
>
>This was filed as Bugzilla #7716 and fixed by Patrick McHardy in 2.6.20.
>
>Did I mess up by not also confirming back to the list that the bug was
>fixed by the patch provided by Patrick?  I think at the time I just
>moved it to Bugzilla because the list post had produced no reaction.

Well yeah I was kinda lazy to check it out myself, so the mail just
remained in the lkml folder until today when I felt like -- oh try
that yourself now that you have some production box >= 2.6.19
somewhere.


	Jan
-- 
