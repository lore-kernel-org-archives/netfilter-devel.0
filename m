From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: H.323 progress.
Date: Wed, 19 May 2004 08:03:41 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AA6C1D.2000105@sauce.co.nz>
References: <Pine.LNX.4.33.0405181044330.32272-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.33.0405181044330.32272-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

> 
> I abandoned the H.323 helper modules because in the present form they work
> only in the most simple cases and the modules cannot be improved without
> really implementing a H.323 parser. That, however, would require too much
> time from me, dedicated to this single task.
> 
> If you have got such equipments as Via Video and Tandberg, better set up a
> H.323 gatekeeper in proxy mode and configure the firewall to allow the
> traffic to/from the gatekeeper in the port range you specified. Such
> setups work fine and reliably. (However, it seems some Microsoft
> netmeeting versions don't obey to communicate fully trough the proxy.)
> 

Hi Jozsef,

Thank you very much for your reply. I have spent some time experimenting 
with gnuGK as a proxy in the following test setup:

Tandberg(192.168.3.0/24)->IptablesNAT-VPN(10.0.0.0/24)->IptablesNAT-VPN->

----->Tandberg(192.168.4.0/24)
|---->gnuGK in H.323 proxy mode (192.168.4.0/24)

Again, this does not complete all connections.

Your suggestion seems to be to configure the Tandbergs to use the 
10.0.0.0/24 addresses, port forwarded through to gnuGK. Is this 
functionally different to what I have? If so, perhaps I am having 
compatibilty problems with gnuGK and Tandberg.

Kind regards,

Richard
