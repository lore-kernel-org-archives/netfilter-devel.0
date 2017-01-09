From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/7] xtables: use dedicated copy_to_user helpers
Date: Mon, 9 Jan 2017 17:30:50 +0100
Message-ID: <20170109163050.GA2299@salvia>
References: <1483395586-105774-1-git-send-email-willemdebruijn.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, fw@strlen.de, dborkman@iogearbox.net,
        Willem de Bruijn <willemb@google.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483395586-105774-1-git-send-email-willemdebruijn.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 02, 2017 at 05:19:39PM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> xtables list and save interfaces share xt_match and xt_target state
> with userspace. The kernel and userspace definitions of these structs
> differ. Currently, the structs are copied wholesale, then patched up.
> The match and target structs contain a kernel pointer. Type-specific
> data may contain additional kernel-only state.
> 
> Introduce xt_match_to_user and xt_target_to_user helper functions to
> copy only fields intended to be shared with userspace.
> 
> Introduce xt_data_to_user to do the same for type-specific state. Add
> a field .usersize to xt_match and xt_target to define the range of
> bytes in .matchsize that should be shared with userspace. All matches
> and targets that define kernel-only data store this at the tail of
> their struct.

Series applied, thanks a lot Willem!
