From: Patrick McHardy <kaber@trash.net>
Subject: Re: FIX: connlimit NULL pointer kernel panic
Date: Sat, 11 Jun 2005 17:03:14 +0200
Message-ID: <42AAFD32.1000608@trash.net>
References: <20050519075405.7DF8640023@socios.momona.org>
	<428C78CE.2040904@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: mateusz@republika.pl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <428C78CE.2040904@eurodev.net>
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

Pablo Neira wrote:
> Forte Systems - Iosif Peterfi wrote:
> 
>> Here is a diff -urN patch for what has been discussed except the
>> conntrack
>> event-api. Works fine on 2.6.1-gentoo-r8, patch-o-matic-ng-20050516. 
> 
> 
> Hm, didn't I also tell you that you have to sed
> 's/spin_unlock/spin_unlock_bh'?
> 
> well, it doesn't matter, attached the correct patch that applies cleanly
> to pom-ng.

Thanks Pablo, I've applied the patch. Can you send patches for the 2.4
and the old 2.6 version too?

Regards
Patrick
