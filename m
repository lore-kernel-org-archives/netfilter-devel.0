From: Xemul <epv_xemul@mail.ru>
Subject: Traffic limitation with iptables
Date: Tue, 22 Jul 2003 20:07:06 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030722200706.43891e40.epv_xemul@mail.ru>
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

Hi.
I wanna solve such a problem:
When I see that byte counter on some chain reaches or exceedes any fixed
value - then IMMEDIATELY insert into that cahin new first rule (e.g. -j
DROP) or delete some rules from any other chain. Or more abstract - how
can can discover that byte counter is higher than smth without
"polling" chains?
