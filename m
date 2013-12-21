From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 2/2] libnetfilter_queue: add support for UID/GID
 socket info
Date: Sat, 21 Dec 2013 13:11:26 +0100
Message-ID: <20131221121126.GA27133@localhost>
References: <1387556934-7372-1-git-send-email-valentina.giusti@bmw-carit.de>
 <1387556934-7372-3-git-send-email-valentina.giusti@bmw-carit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	jpa@google.com, fw@strnel.de, daniel.wagner@bmw-carit.de
To: valentina.giusti@bmw-carit.de
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1387556934-7372-3-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Dec 20, 2013 at 05:28:54PM +0100, valentina.giusti@bmw-carit.de wrote:
> @@ -1180,6 +1183,18 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
>  }
>  EXPORT_SYMBOL(nfq_get_packet_hw);
>  
> +uint32_t nfq_get_uid(struct nfq_data *nfad)
> +{
> +	return ntohl(nfnl_get_data(nfad->data, NFQA_UID, u_int32_t));
> +}
> +EXPORT_SYMBOL(nfq_get_uid);

Given that we'll have cases in which uid would not be present, I think
that the following interface would be better:

        int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)

The function returns 1 if uid has been set (ie. it's available so you
can access it), otherwise it returns 0.

Same thing for _get_gid().

Thanks.
