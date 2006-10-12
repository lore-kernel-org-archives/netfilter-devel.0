From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipq and nf_queue compatibility
Date: Thu, 12 Oct 2006 02:59:44 +0200
Message-ID: <452D9380.7030803@trash.net>
References: <A204A2FA-BD7D-410F-B6AB-EB61B894DB28@cadvium.net>
	<452C8828.6000005@trash.net>
	<C15F0529-23F1-4953-BF4D-0CEEC3309473@cadvium.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: robert <rbscott@cadvium.net>
In-Reply-To: <C15F0529-23F1-4953-BF4D-0CEEC3309473@cadvium.net>
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

robert wrote:
> is there any sequence that will insure both ipq and nfqueue work?  
> should it just never unbind then?  I am a little unclear what the 
> difference is between unregister and unbind?

You need to unload/reload the ip_queue module if you want it
to register again after "unbinding" nfnetlink_queue from
AF_INET.
