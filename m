From: "Alexander Sirotkin" <demiourgos@gmail.com>
Subject: TCP/UDP checksum in hardware
Date: Sun, 4 Mar 2007 17:26:04 +0200
Message-ID: <c4357ccd0703040726ie905103rd60c87c8a35923c8@mail.gmail.com>
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

It appears that Netfilter does not exploit the hardware TCP/UDP
checksum functionality present in some network cards, i.e.
NETIF_F_HW_CSUM. Is there any particular reason why it is not used ?

The reason I'm asking is that computing checksum (in case of NAT, for
instance) becomes a real problem on embedded devices
