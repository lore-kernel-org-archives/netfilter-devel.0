From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter_queue reinjecting packets
Date: Tue, 14 Mar 2006 17:46:28 +0100
Message-ID: <4416F364.8090105@trash.net>
References: <1142119489.2987.61.camel@localhost>	<20060312151054.5a2020ad.aton@packetdropped.org>	<441433C2.6010901@trash.net>	<20060312202133.08f8d8ee.aton@packetdropped.org>	<4414780C.60907@trash.net>
	<20060314135452.19a2b219.aton@packetdropped.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: aton <aton@packetdropped.org>
In-Reply-To: <20060314135452.19a2b219.aton@packetdropped.org>
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

aton wrote:
> okay i seem to understand how it works a bit better now. 
> what i dont understand is how to get the ethernet header from the library.
> i tried nfq_get_packet_hw(), but it always returns NULL, is that correct?

The hardware header is only included for packets queued on
the input path.
