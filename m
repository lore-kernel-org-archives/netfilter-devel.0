From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libmnl 1/2] socket: introduce mnl_socket_open2()
Date: Mon, 5 Oct 2015 17:37:15 +0200
Message-ID: <20151005153715.GA22955@salvia>
References: <cover.1443815157.git.g.nault@alphalink.fr>
 <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guillaume Nault <g.nault@alphalink.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57096 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbbJEPaU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 11:30:20 -0400
Content-Disposition: inline
In-Reply-To: <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 02, 2015 at 10:12:33PM +0200, Guillaume Nault wrote:
> Define mnl_socket_open2() so that user can pass a set of SOCK_* flags
> at socket creation time.
> 
> Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
> ---
>  include/libmnl/libmnl.h |  3 ++-
>  src/libmnl.map          |  1 +
>  src/socket.c            | 41 ++++++++++++++++++++++++++++++++---------
>  3 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> index 3a589bc..5adb13c 100644
> --- a/include/libmnl/libmnl.h
> +++ b/include/libmnl/libmnl.h
> @@ -21,7 +21,8 @@ extern "C" {
>  
>  struct mnl_socket;
>  
> -extern struct mnl_socket *mnl_socket_open(int type);
> +extern struct mnl_socket *mnl_socket_open(int bus);
> +extern struct mnl_socket *mnl_socket_open2(int bus, int flags);

Looks good, but we should be using 'unsigned int flags' instead, right?

Or am I missing anything?
