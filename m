From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Time match in mangle/POSTROUTING?
Date: Tue, 19 Dec 2006 13:10:17 +0100
Message-ID: <4587D6A9.8080207@trash.net>
References: <1166462375.27555.52.camel@palocortado>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: brad@info-link.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alejandro David Galera Ruiz <alejandro.galera@gmail.com>
In-Reply-To: <1166462375.27555.52.camel@palocortado>
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

Alejandro David Galera Ruiz wrote:
> I'm trying to use netfilter with classify and temporal filters. Due to I
> realised that POSTROUTING wasn't supported in mangle table, I decided to
> patch ipt_time module following Brad Fisher's PATCH.
> 
> I've tried to update this patch for kernel 2.6.17 and the lastest
> version of patch-o-matic (20061213).
> It's my first contribution to this project, I hope to be a little bit
> useful for your great project.
> 
> Using: 
> Patch-o-matic 20061213
> 
> Modifications:
> 
> * Time modification (the same from Brad Fisher
> http://lists.netfilter.org/pipermail/netfilter-devel/2003-December/013367.html) 

Your mailer mangled the patch, please resend as attachment.
