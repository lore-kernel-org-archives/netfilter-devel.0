From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.17.1 compile error with a netfilter module
Date: Fri, 30 Jun 2006 17:28:19 +0200
Message-ID: <44A54313.4050901@trash.net>
References: <925A849792280C4E80C5461017A4B8A206F783@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A206F783@mail733.InfraSupportEtc.com>
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

Greg Scott wrote:
> Does anyone know what this means and how to fix it?  I know it looks
> like a file named lockhelp.h is missing.  I guess my question is, what
> can I do to fix it?
> 
> With this build, I tried to put in some POM patches from
> patch-o-matic-ng-20060624.  Could this have been my problem? 

Yes. It looks like you managed to apply some old 2.4 patches :)
If you don't need them I'd suggest to just don't use them.
