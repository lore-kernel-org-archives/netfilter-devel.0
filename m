From: "Andriy T. Yanko" <wireless@wireless.org.ua>
Subject: filling ipt_entry
Date: Thu, 10 Jul 2003 17:31:50 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030710173150.545ee3e2.wireless@wireless.org.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Hi

I'd like create a simple rule for INPUT chain with my progam wich use libiptc  like it do iptables progam:
iptables -A INPUT -s 192.168.1.1 - j ACCEPT

Please show me piece of code how to fill ipt_entry in this case?
I don't now how to  add right  target offset.

THANKS IN ADVANCE.

-- 
Andriy T. Yanko
wireless@wireless.org.ua

*   Avoid The Gates of Hell use Linux
**  Wenn ich sterbe, legt mir eine Birne in mein Grab ...
