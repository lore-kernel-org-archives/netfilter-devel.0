From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipt_time.so removed?
Date: Wed, 17 Jan 2007 20:05:17 +0100
Message-ID: <45AE736D.40503@trash.net>
References: <002501c73a5c$f791d3c0$310412ac@king>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grant <grant@mufasa.za.net>
In-Reply-To: <002501c73a5c$f791d3c0$310412ac@king>
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

Grant wrote:
> Has libipt_time.so been removed from the newest SVN source ? After
> applying the patch-o-matic  patches (./runme --download, ./runme extras)
> I rebuild kernel and modules. The ipt_time.ko is built fine, re-compling
> iptables-1.3.7, libipt_time.so is missing in /usr/lib/iptables/ or
> /usr/local/lib/iptables/. Plans to return it ?


All extensions for unmaintained or external patches and obsolete
features were removed from iptables SVN. I suggest you ask the
time patchlet maintainer to add it to the repository.
