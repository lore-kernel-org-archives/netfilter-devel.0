From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re[2]: Multiple Targets
Date: Sat, 19 Feb 2005 10:23:31 +0100
Message-ID: <1589344960.20050219102331@dns.toxicfilms.tv>
References: <7174b1e405021900052b4545c4@mail.gmail.com>
	<20050219082851.GA18228@oknodo.bof.de>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050219082851.GA18228@oknodo.bof.de>
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

Hello Patrick,

Saturday, February 19, 2005, 9:28:51 AM, you wrote:
> Problem: target options. How would the commandline parser see that
> --set-mark belongs to MARK, and --log-prefix belongs to LOG? What
> about the hypothetical case of several targets having target options
> with identical names?
This is all very interesting.
But do we want this because we want just better looking rulesets or
have it optimized in sense of matchinge the packets?

I think the latter. So how about leaving the iptables semantics left as
they are, but changing it so it does recognize rules with identical
matching rules and somehow compiling the two (or more) of them into
a single rule that kernel-space would understand.
Example:

We write these 3 rules:
iptables -A INPUT -p tcp --dport 53 -j LOG --log-prefix "foo: "
iptables -A INPUT -p tcp --dport 53 -j MARK --set-mark 1
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

iptables reads these 3 rules but creates one complex rule for that in
kernel-space that would read:
match tcp dport 53 packets on INPUT and do
1) LOG --log-prefix "foo: "
2) MARK --set-mark 1
3) ACCEPT

Of course there can be only one rule that ends with a returning verdict:
ACCEPT,DROP,REJECT.

This way only the kernel core since some new version would do this,
others would do it the standard way. Binary compatibility retained.

-- 
Best regards,
Maciej
