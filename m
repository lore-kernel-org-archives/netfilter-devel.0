From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
	and optimization
Date: Thu, 24 Jun 2004 10:13:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1088064830.3104.21.camel@jds.i.dns-hungary.hu>
References: <200406240404.NAA01264@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Harald Welte <laforge@netfilter.org>,
   usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200406240404.NAA01264@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Yasuyuki,

you saved my life :)
When I tried to do the same a was not able to track behaviour of
skb->nh. (There was some grey point, like when the packet leaves the
machine over the tunnel interface.)

> "protoff" is the offset of transport protocol header from skb->data.
> match modules can get the transport protocol header without skipping IPv6
> extension headers.
(Its OK, since we have some code which uses the extension headers.)

> 	- In all match module, the only arguments of match() are changed.
I think it is not a problem since the ip6tables - as I know - not a
'core' product. We can break the compatibility / usability of these
extensions. (And it will push us to fix the problems and sync the
matches with the IPv4 parts.)
Could you add an #error string right after the definitions in the
matches?
In this case the compilation of the matches will cause strange error
messages - and someone have to answer all of them. An error message
should help a little bit. (Eg.: Known error point. This part is under
reconstruction. Please, be patient. etc.)

Many thanks again,

Best regards,

Andras

-- 
Andras Kis-Szabo <kisza@securityaudit.hu>
