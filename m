From: =?ISO-8859-1?Q?Gr=E9gory?= <gregory.wajs@free.fr>
Subject: Logs behind a transparent proxy
Date: Fri, 24 Jan 2003 00:13:47 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1043363627.3e30772b136d4@imp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
I'd like to make a "really" transparent bridge using a proxy.
Though when  watching my logs on my server (behind the bridge), I
always get the proxy IP  (which is normal). I'd like to know if
there's an existing patch to iptables that could hide the proxy's
adress by putting back the real source adress when the traffic is
coming from Internet.

Gregory
