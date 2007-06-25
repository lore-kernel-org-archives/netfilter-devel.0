From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070625
Date: Mon, 25 Jun 2007 17:05:12 +0200
Message-ID: <467FD9A8.2030107@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>	<467BAF07.6020502@trash.net>	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>	<467FA9CE.8000805@trash.net>	<Pine.LNX.4.64.0706251405280.3137@fbirervta.pbzchgretzou.qr>	<467FB87D.9020004@trash.net>	<Pine.LNX.4.64.0706251451000.3137@fbirervta.pbzchgretzou.qr>	<467FD52E.4050705@trash.net>
	<Pine.LNX.4.64.0706251701180.3137@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706251701180.3137@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jun 25 2007 16:46, Patrick McHardy wrote:
> 
>>>Thing is..
>>>static int count_them(struct xt_connlimit_data *data, u_int32_t addr,
>>>                      u_int32_t mask, struct nf_conn *ct)
>>>
>>>I'd need a u_int128_t for IPv6. (Or a clever idea.)
>>>Suggestions for elegant solution?
>>
>>struct xt_conntrack_address
> 
> 
> Is that something I yet have to invent, or is it part of some other git tree?

nf_conntrack_address. Should be somewhere under include/net I think.
