From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 17:31:18 +0200
Message-ID: <44E09746.60302@trash.net>
References: <44E07BCD.8030206@trash.net>	<20060814142559.GS7194@kriss.csbnet.se>	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814152026.GU7194@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> Alot of my patches can use it. Not having todo an ugly solution trying to
> sneak away from being reseted when another rule is altered. I sure would
> like to have it added. Simpyl do not change for example -m limit into using
> it if it breaks the "feature" of reseting its state then altering another
> unrelated rule.

I forgot to reply to this. You seem to misunderstand, limit doesn't
reset its state today. It will when moving private data out of the
structures shared with userspace. Same for all other users of this,
they will "forget" their state on each ruleset change.
