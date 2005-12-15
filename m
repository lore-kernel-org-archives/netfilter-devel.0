From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Thu, 15 Dec 2005 02:30:49 +0100
Message-ID: <43A0C749.2050901@trash.net>
References: <439419A7.7040100@eurodev.net>
	<200512090241.jB92fXDR003303@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512090241.jB92fXDR003303@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
>>Attached the 3rd incarnation of the ctnetlink port to nf_conntrack, it
>>includes all recent Patrick's bugfixes and Yasuyuki's comments.
>>
>>nf_conntrack_netlink.c is available at:
>>http://people.netfilter.org/pablo/nf_conntrack_netlink.c
> 
> Great work.
> 
> I have 2 more comments as follows. I'll send patches for them and
> adding support for ICMPv6 in other mails.

Apart from these minor issues, I'm fine with the patch too.
I'll apply it tommorrow if noone objects.
