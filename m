From: "David S. Miller" <davem@redhat.com>
Subject: Re: [RESEND][PATCH] net/ipv6/netfilter warnings removal
Date: 23 Apr 2003 21:50:44 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051159844.18160.1.camel@rth.ninka.net>
References: <Pine.LNX.4.51.0304051607310.32140@dns.toxicfilms.tv>
	 <Pine.LNX.4.51.0304072115010.19830@dns.toxicfilms.tv>
	 <Pine.LNX.4.51.0304231434540.4838@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0304231434540.4838@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-23 at 05:38, Maciej Soltysiak wrote:
> And here is the patch to remove those by using casts.

It's kind of rediculious that these modules don't use the
existing AH/ESP/etc. header structure types (ip_auth_header et
al.)

That's why I'm not applying this patch, please fix all of these
modules up to use the same header structures as the IPSEC layer
does.  Then I'll take the patch.

Thanks.

> -- 
> David S. Miller <davem@redhat.com>
