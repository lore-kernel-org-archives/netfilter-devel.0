From: zhongyu <xxx@mail.goldenhope.com.cn>
Subject: =?HZ-GB-2312?Q?Re:the_solution_to_synflood_on_netfilter_=28?=
 =?HZ-GB-2312?Q?~{V#~}~{4+~}~{2=28~}=29?=
Date: Fri, 26 Dec 2003 14:03:53 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <48C150C9-3769-11D8-8C63-000A95B170F8@mail.goldenhope.com.cn>
References: <20031226052637.5955.69361.Mailman@netfilter-sponsored-by.noris.net>
Mime-Version: 1.0 (Apple Message framework v609)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20031226052637.5955.69361.Mailman@netfilter-sponsored-by.noris.net>
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

There was a syn-cookie firewall patch for linux-2.2 ipchains.  I had 
hacked it to 2.4 kernel.
But it was very dirty and had problems under bridge mode... Is there a 
clean way to write a
syn-cookie firewall in iptables framework?
