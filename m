From: "Michael Varga" <mike.varga@cavium.com>
Subject: netfilter hook not working with fragments
Date: Wed, 9 Feb 2005 21:59:04 -0800
Message-ID: <19c901c50f35$a4afb8b0$a610a8c0@niche>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>,
	<netfilter@lists.netfilter.org>
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

Hi,

I wrote a NF_IP_PRE_ROUTING hook to capture packets
for an IPSec implimentation.

Is there a way to make netfilter assemble fragments before=20
recieving them in my netfilter hook?

thanks
Mike
