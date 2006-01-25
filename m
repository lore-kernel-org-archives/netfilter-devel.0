From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT in kernel >= 2.6.15 broken???
Date: Wed, 25 Jan 2006 11:05:28 +0100
Message-ID: <43D74D68.5090808@trash.net>
References: <43D74B7D.000002.25194@pantene.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dkiba@yandex.ru
In-Reply-To: <43D74B7D.000002.25194@pantene.yandex.ru>
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

KdF wrote:
> Is there a problem with REDIRECT in kernels >= 2.6.15?
> 
> We are using 2.6.14 on a router and billing stations, and users with exceeded quotas are redirected to local server, but after test upgrade to 2.6.15, 15.1 and 16-rc1 REDIRECT seems not to work :(
> 
> Packets get forwarded as usual without any attempt to be redirected.
> Netfilter is built as a part of whole kernel, not a module.
> DNAT does not work too in this case, but 2.6.14.6 works fine on same ruleset and kernel config.

Works fine for me. Please post some details about your setup, the
exact rules you're using and what (if any) patches you've applied.
