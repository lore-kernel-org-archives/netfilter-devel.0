From: "Yong Li" <sdssly@sina.com>
Subject: IP fragment question?
Date: Sat, 16 Aug 2003 09:47:57 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000c01c36398$6d9d9ad0$bb42f2da@win2ken>
References: <20030731222640.2767.4272.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello All,

I installed a hook on IP FORWARD point. If I modify the skb len > MTU. the
packet cannot be sent. However, I foun Linux calls the ip fragment function
in the ip xmit function in ip_output.c. Why this modified skb missing?

Do I need to perform the IP fragment task?

If so, can I perform the task in this hook function?

Thank you
