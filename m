From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: Suggestions for some patch-o-matic extensions (comment, ipp2p,
 random, etc...)
Date: Wed, 16 Feb 2005 19:00:16 -0500
Message-ID: <4213DE90.7060106@cookinglinux.org>
References: <4213C6FD.5080705@arcoscom.com> <4213CF7F.6060901@arcoscom.com>
	<4213D403.3000202@cookinglinux.org> <4213DB25.1080604@arcoscom.com>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: =?ISO-8859-1?Q?Samuel_D=EDaz_Garc=EDa?= <samueldg@arcoscom.com>
In-Reply-To: <4213DB25.1080604@arcoscom.com>
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

Samuel Díaz García wrote:
> Well, I have 3 iptables extensions patched for the use with iptables 1.3.0.
> 
> libipt_comment.c
> libipt_ipp2p.c
> libip6t_random.c
> 
> They are compiling fine now (after I done some changes in the "struct 
> iptables_match" variable definition.
> 
> The way to correct compile errors is revise the "struct iptables_match" 
> variable definition.

Please take a look at :
https://lists.netfilter.org/pipermail/netfilter-devel/2005-February/018468.html

comment and ipp2p are done yet.

Patch for 6_random is, I guess, welcome.

 > [...]
> 
>    Samuel Díaz García
>     Director Gerente
> ArcosCom Wireless, S.L.L.


Best regards,
Samuel
