From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v4 0/3] Implement --echo option
Date: Mon, 14 Aug 2017 11:26:51 +0200
Message-ID: <20170814092651.GA7437@salvia>
References: <20170809111643.18906-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45458 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752586AbdHNJ1R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 05:27:17 -0400
Content-Disposition: inline
In-Reply-To: <20170809111643.18906-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 09, 2017 at 01:16:40PM +0200, Phil Sutter wrote:
> Long description of what it is and how it works in patch 3. Patch 1 is a
> dependency to patch 2, Patch 3 adds a simple test suite which was
> helpful during development.

Applied, but please follow up asap to address a couple of issues:

mnl.c: In function ‘nft_mnl_talk_cb’:
mnl.c:82:5: warning: ‘rc’ may be used uninitialized in this function
[-Wmaybe-uninitialized]
  if (rc)
     ^

        struct nft_mnl_talk_cb_data {
                int (*cb)(const struct nlmsghdr *nlh, void *data);
                void *data;
        };

        static int nft_mnl_talk_cb(const struct nlmsghdr *nlh, void *data)
        {
                struct nft_mnl_talk_cb_data *cbdata = data;
                int rc;

                if (cbdata->cb)
                        rc = cbdata->cb(nlh, cbdata->data);
                if (rc)
                        return rc;
                return netlink_echo_callback(nlh, cbdata->data);
        }

This code above doesn't look fine...

Apart from this, this struct nft_mnl_talk_cb_data looks... a bit
convoluted ;)

        static int
        nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
                     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
        {
                uint32_t portid = mnl_socket_get_portid(nf_sock);
                struct nft_mnl_talk_cb_data tcb_data = {
                        .cb = cb,
                        .data = cb_data,
                };

        #ifdef DEBUG
                if (debug_level & DEBUG_MNL)
                        mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
        #endif

                if (mnl_socket_sendto(nf_sock, data, len) < 0)
                        return -1;

                return nft_mnl_recv(nf_sock, seq, portid, &nft_mnl_talk_cb, &tcb_data);
        }

Why don't you simply pass the callback that you need to nft_mnl_recv()
instead of adding this extra unnecesary abstraction...

Please, follow up with a patchset to address this.

Thanks!
