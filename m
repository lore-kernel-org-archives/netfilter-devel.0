From: "noa levy" <noalevy@gmail.com>
Subject: SNAT before IPSec
Date: Tue, 5 Jun 2007 01:43:59 +0300
Message-ID: <8bd3dfad0706041543s1a6863ddpc1fd4fb1fd05f6a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi All,

I have a setup where I need to SNAT traffic that will be going out via
an IPSec tunnel. The NAT must take place before the IPSec
encryption+encapsulation, so I need the packet to first go through
SNAT and then match an IPSec policy. After being IPSec-ified, I need
the packets to go through routing again.
My question:
SNAT takes place in POST_ROUTING. Can IPSec be applied after that? I
have read that after IPSec the packet gets injected to LOCAL_OUT
again, but when does the actual IPSec policy decision take place?
Won't it happen *before* SNAT? Can I control it?

Thanks,

Noa
