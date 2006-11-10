From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: new code; iptables-xml for iptables package.
Date: Fri, 10 Nov 2006 15:43:47 +0100
Message-ID: <45549023.40801@netfilter.org>
References: <455311B5.5000600@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <455311B5.5000600@ufomechanic.net>
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

Amin Azez wrote:
> (I hope these can be added to the standard iptables package)
> 
> Here is iptables-xml based on iptables-restore (as it knows how to parse
> iptables-save format), along with some xslt that converts back to
> iptables-save format.
> 
> A typical null use would be:
> 
>   iptables-save -c | iptables-xml -c | xsltproc iptables.xslt -

Just a wild thought, why not go further and provide a native XML 
interface instead of a converter?

BTW, could you also provide a DTD (Document Type Definition)? It can be 
interesting to check for well-formed documents.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
