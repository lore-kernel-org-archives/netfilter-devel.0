From: Philip Craig <philipc@snapgear.com>
Subject: Re: nat: expected connection only works one way
Date: Tue, 28 Oct 2003 18:38:31 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9E2B07.3060707@snapgear.com>
References: <26158.1067264889@www3.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: n_dahlem@gmx.net
In-Reply-To: <26158.1067264889@www3.gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

n_dahlem@gmx.net wrote:
> Sniffing between Masq and Host1, one can see that the packets coming from
> host2 get nat'd and an answer is send:
> 10.20.10.198:5020 -> 172.30.8.100:5006
> 172.30.8.100:5006 -> 10.20.10.213:5020

The second packet is not a reply to the first.
Its destination is Masq, not Host2.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
