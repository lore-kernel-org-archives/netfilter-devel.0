From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [testsuite] ipt_multiport testcase
Date: Sat, 01 Jan 2005 23:06:04 +0100
Message-ID: <41D71ECC.2090402@eurodev.net>
References: <41C3BFB7.3030901@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org,
	Nicolas Bouliane <nib@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <41C3BFB7.3030901@cookinglinux.org>
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

Samuel Jean wrote:

># Multiport doesn't support invert nor complains about it. (expecting: answer from rusty)
># Do we still test it Rusty ?
>iptables -I INPUT -p tcp -m multiport ! --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>iptables -D INPUT -p tcp -m multiport ! --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>iptables -I INPUT -p tcp -m multiport ! --destination-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>iptables -D INPUT -p tcp -m multiport ! --destination-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>iptables -I INPUT -p tcp -m multiport ! --ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>iptables -D INPUT -p tcp -m multiport ! --ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>  
>

Phil Oester sent a patch to fix this some time ago, see:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-September/016797.html

so it's fixed. BTW, thanks, your testsuites let me same quite some time.

--
Pablo
