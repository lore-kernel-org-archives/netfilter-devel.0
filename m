From: "Tarek W." <faqmaster@iptables.org>
Subject: Re: question regarding iptables tuning (was Re: iptables denial of
	services)
Date: Sun, 18 Apr 2004 15:55:53 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1082292886.2304.13.camel@carve.personal.localdomain>
References: <Pine.LNX.4.44.0404171843020.22016-100000@filer.marasystems.com>
	 <408167F2.9060501@fl.priv.at> <408180C7.6080302@eurodev.net>
	 <40818C75.8010609@fl.priv.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40818C75.8010609@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2004-04-17 at 22:58, Friedrich Lobenstock wrote:
> Pablo Neira wrote on 17.04.2004 21:08 MET:
> > Hi Friedrich,
> > 
> > Friedrich Lobenstock wrote:
> > 
> >> Any suggestions for those parameters that are based on your experiences?
> > 
> > 
> > maybe this could be interesting for you, it's related to conntrack system.
> > 
> > http://www.wallfire.org/misc/netfilter_conntrack_perf.txt
> > http://bei.bof.de/
> > 
> > I don't know how up to date they are, actually they are still in my 
> > queue of things to be read ;-).
> 
> BIG THANKS for the links!
> 
> May I suggest to add the first link to the faq?

it will be, the answer will also reflect this thread... unfortunately,
there remains the matter of a missing Makefile to generate the FAQ from
the latest xml sources, if anybody would like to contribute one, please
submit it to this list.

if anybody would like to take a peek at the latest FAQ in html, it's
available at http://ticallion.lonecoder.net/pub/faq/, when the Makefile
issue is resolved, it will be available at netfilter.org
