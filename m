From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: Re: New extension: CRYPT target
Date: Tue, 23 May 2006 14:19:01 -0300
Message-ID: <44734405.3000300@speedy.com.ar>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
	<4470D859.7000706@speedy.com.ar>
	<10007.1148252261@sandelman.ottawa.on.ca>
	<44724AE0.5040708@speedy.com.ar>
	<22306.1148389730@sandelman.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <22306.1148389730@sandelman.ottawa.on.ca>
To: netfilter-devel@lists.netfilter.org
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

Michael Richardson wrote:
> 
> 
>>>>>>>"Gervasio" == Gervasio Bernal <gervasiobernal@speedy.com.ar> writes:
> 
>     Gervasio> The idea behind CRYPT extension is not to replace IPSEC
>     Gervasio> absolutely, but to be a simple alternative of use for
>     Gervasio> encryption/decryption and packet authentication using
>     Gervasio> Iptables. It could be useful for somebody.
> 
>   Tell me the threat model.
> 
>   Under what circumstances is it better than:
> 	a) IPsec with OE (with is dirty simple to configure)
> 	b) TLS/SSL LD_PRELOAD wrapper
> 	c) using SCP instead of FTP (or rsync over SSH)
> 	d) OpenVPN or SSH port forwarding
> 	e) HIP

Perhaps in none of those circumstances.
CRYPT extension is just an alternative, as well OpenOffice Writer is an
alternative of Microsoft Word. It is good to have several different
alternatives.

> 
>     Gervasio> We have also developed a module in Python that use the
>     Gervasio> CRYPT extension, configuration files, has automatic key
>     Gervasio> management and user authentication using certificates. But
>     Gervasio> we need that someone else can test first the extension
>     Gervasio> alone, and comments its experience to us.
> 
>   Why in the world would you build such a complicated system? 

It is much more easy of which you imagine. You only have to run a Python
application and voila!!

>   You just told us that you wanted something simpler than IPsec.
> 
>   It seems like vanity crypto to me.
> 
