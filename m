From: Patrick McHardy <kaber@trash.net>
Subject: /proc/net/ip_conntrack permissions
Date: Wed, 02 Jun 2004 04:13:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40BD37D9.5020704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've added a patch to change /proc/net/ip_conntrack permissions
to 0440. It contains privileged information and shouldn't be
world readable. I was just wondering why this hasn't been done
before, does anyone know a good reason not to change it ?

Regards
Patrick
