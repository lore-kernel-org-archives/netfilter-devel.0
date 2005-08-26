From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [RFC] TTL target goes mainline ?
Date: Fri, 26 Aug 2005 19:27:29 +0200
Message-ID: <391310336.20050826192729@dns.toxicfilms.tv>
References: <20050826111832.GT4226@rama.de.gnumonks.org>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050826111832.GT4226@rama.de.gnumonks.org>
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

Hi!

> So my proposal is to only allow decrementing (or setting to a value
> below the original one) the TTL unless CONFIG_EXPERIMENTAL is set. 

> What do you think?
Not that my vote counts or anything but as a user and an ocasional
netfilter hacker I belive it is best to either:
- submit the target with its current set of options (decreasing, increasing,
  setting to a value) acompanied by EXPERIMENTAL flag and a warning in the
  help screen, maybe even an additional text in the option line, like
  "[m] TTL target (warning: see help!)"
- *or* leave it in pom-ng, so only people who now what they are doing would
  use it.

nb. This means that IPv6 HOPLIMIT should go in too. I guess.

-- 
Best regards,
Maciej
