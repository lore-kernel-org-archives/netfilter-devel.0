From: Ozgur AKAN <akan@aiqa.com>
Subject: Re: iptables denial of services
Date: Fri, 16 Apr 2004 10:10:37 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407F86ED.4090706@aiqa.com>
References: <20040415183141.40EC43D96DC@smtp.latinmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jorge Garcia <anarkophobia@latinmail.com>
In-Reply-To: <20040415183141.40EC43D96DC@smtp.latinmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jorge Garcia wrote:

>I saw in the net that for examples servers like apache or smtp stop his services after a determinated numbers of connections at the same time.
>Is this a problem in iptables firewall??i mean does iptables stop filtering after handling a lot of traffic?
>
I think just the opposite would occur. The load of linux os raises to a 
degree that firewall can not answer any more requests.

>The other thing i saw in the net is that it is possible to send a lot of traffic to full the log messabges of iptables and the firewall will stpo filtering so a hacker could acces to different services on the net,
>
If you mean creating too much log and filling the disk space, there is a 
limit option which can limit the number of packets to log in a period of 
time.

-- 
Ozgur Akan
