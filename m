From: Pablo Neira <pablo@eurodev.net>
Subject: Re: latest pom: base/connlimit breaks kernel 2.4.25 compile (+possible
 fix)
Date: Sat, 10 Apr 2004 18:52:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4078264C.5000909@eurodev.net>
References: <40780CAD.6080305@fl.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Friedrich Lobenstock <fl@fl.priv.at>, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Friedrich,

Friedrich Lobenstock wrote:

>-	/* NULL if ip_conntrack not a module */
>-	if (ip_conntrack_module)
>-		__MOD_INC_USE_COUNT(ip_conntrack_module);
>+	/* NULL if ip_connlimit not a module */
>+	if (ip_connlimit_module)
>+		__MOD_INC_USE_COUNT(ip_connlimit_module);
> 	return ipt_register_match(&connlimit_match);
> }
>
>  
>
AFAIK, the use of __MOD_INC_USE_COUNT is deprecated, actually I remember 
that someone posted to the maillist a related issue and Harald finally 
decided to remove them. If I'm missing anything, please let me know.

So I think that you could remove them, you could also post a patch to 
update the current match available in pom-ng :-).

regards,
Pablo
