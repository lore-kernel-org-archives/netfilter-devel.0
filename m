From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: Re: [RESEND][PATCH] Hop Limit match/target for IPv6
Date: Thu, 02 Jan 2003 20:39:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1041536390.938.1.camel@arwen.middleearth.hu>
References: <Pine.LNX.4.44.0301021931270.8422-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-reply-to: <Pine.LNX.4.44.0301021931270.8422-100000@dns.toxicfilms.tv>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
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

> The patch i send lately, has a nested comment which fails to compile
> Like this:
> /* bla
>  * bla */
>  */
> 
> Just need to remove the nested */ in the middle there.
> 
> It appears twice in include/linux/netfilter_ipv6/ip6t_HL.h in
> the netfilter include directory and in the patch-o-matic kernel patch.
Could You send the modified patch to the list?

Regards,

	kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /------------------------------------------->
