From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] MARK target doesn't allow to set highest bit
Date: 04 Nov 2002 18:36:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <veu1ixb5k6.fsf@inigo.ingate.se>
References: <veu1j2de35.fsf@inigo.ingate.se>
	<20021102153816.O8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021102153816.O8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte <laforge@gnumonks.org> writes:

> > libipt_MARK.c has been broken since iptables 1.2.7.  This patch
> > makes it work properly again:
> 
> Broken in which way?  Am I right you are talking about signed/unsigned
> numbers and not being able to specify the upper half of the mark
> range?

Yes, exactly. It worked fine with the old code, but string_to_number()
doesn't handle unsigned numbers.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Firewall Developer, Ingate Systems AB |  http://www.ingate.com/
