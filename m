From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack and IKE confused on 2.6.16
Date: Wed, 22 Mar 2006 18:47:03 +0100
Message-ID: <44218D97.6000002@trash.net>
References: <BAY103-F14003302261358DE14249BB2D90@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F14003302261358DE14249BB2D90@phx.gbl>
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

Marco Berizzi wrote:
> Patrick McHardy wrote:
> 
>> I'm not sure I understand you correctly. The notebook users
>> establishes a VPN to the remote side.
> 
> 
> Yes.
> 
>> Why shouldn't the
>> IKE-traffic be directed back to him?
> 
> 
> lnx and lnx2.6.16 must talk each other to
> establish/renew the ike/ipsec sa, but lnx2.6.16
> is directing packets for itself to the notebook.
> Is this clear?

Not exactly. Is the tunnel between the notebook user and
the remote gateway, between the two gateways or both?
