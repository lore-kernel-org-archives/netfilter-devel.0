From: Michael <oni@atice.org>
Subject: Re: patch-o-matic problem with ip_nat_pptp
Date: Sun, 21 Aug 2005 13:07:29 +1000
Message-ID: <4307EFF1.6050906@atice.org>
References: <E1E4Csn-0005rz-B4@wombat.digitalis.net.au>
	<42FF1CD7.9010209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42FF1CD7.9010209@gmail.com>
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

Jiri Slaby wrote:

> If you want to use pptp with 2.6.11 tree, you have to add nfnetlink 
> patch, because there aren't these functions. The problem is probably, 
> that 2 patches overlap. The best way to use pptp from patch-o-magic is 
> upgrade kernel to one of latest versions.


I've tried updating my kernel version to 2.6.12.5 & grabbed the latest 
patch-o-matic (20050819) When I try to apply the
pptp-conntrack-nat patch, it is now telling me:

newfile: 8 files in our way, unable to apply

any ideas?

--
Michael
oni@atice.org
