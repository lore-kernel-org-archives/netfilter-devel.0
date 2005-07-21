From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: traffic shaping and fixed per-packet overhead
Date: Thu, 21 Jul 2005 09:17:11 +0200
Message-ID: <pan.2005.07.21.07.17.08.357408@smurf.noris.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

I have an IPIP tunnel through a DSL line (PPPoE) which I need to
traffic-shape / flow control. Unfortunately, the tunnel has a fixed
per-packet overhead, which means that small packets overrun the
bandwidth allowed for the tunnel and get dropped, while (if I set the
allowed bandwidth to too-small values) the wire will be idle when
I send large packets.

(I'm using HTB.)

I can think of a couple of solutions ...
- Use bit-banging in the outer filter instead of nice rules on the tunnel.
  (OK, that's a dumb idea from a useability POV.)
- Extend the HTB code to allow specifying a per-packet overhead.
- Hack the kernel to propagate a packet's netfilter MARK.

Other / better ideas?

-- 
Matthias Urlichs  |  {M:U} IT Design @ m-u-it.de  |   smurf@smurf.noris.de
Disclaimer: Das Zitat wurde zufällig ausgewählt.  |   http://smurf.noris.de
 - -
Mußt Du immer meine Fragen, die ich immer schon stellen
wollte, beantworten, _bevor_ ich daran dachte, sie zu äußern.
		-- Gerold Korbus über Joey
