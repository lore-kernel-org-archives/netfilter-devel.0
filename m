From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 3/5] src: set: Do not print unset values in json
Date: Wed, 11 Jun 2014 19:50:26 +0200
Message-ID: <20140611175026.GB17843@localhost>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
 <1402501851-22208-5-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57128 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaFKRub (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:50:31 -0400
Content-Disposition: inline
In-Reply-To: <1402501851-22208-5-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 05:50:49PM +0200, Ana Rey wrote:
> It changes the parse and the snprint functions to omit unset values.
> 
> This json file is gotten for a set:
> {
>   "set": {
>     "name": "mi6set3",
>     "table": "test6",
>     "flags": "0",
>     "family": "unknown",
>     "key_type": "0",
>     "key_len": "0",
>     "set_elem": [
>       {
>         "flags": "0",
>         "key": {
>           "data_reg": {
>             "type": "value",
>             "len": "16",
>             "data0": "0x000080fe",
>             "data1": "0x00000000",
>             "data2": "0xffb30202",
>             "data3": "0x89001efe"
> 
> Now, This json file is gotten for a set without unset elements.
> {
>   "set": {
>     "name": "mi6set3",
>     "table": "test6",
>     "family": "unknown",
>     "set_elem": [
>       {
>         "key": {
>           "data_reg": {
>             "type": "value",
>             "len": "16",
>             "data0": "0x000080fe",
>             "data1": "0x00000000",
>             "data2": "0xffb30202",
>             "data3": "0x89001efe"

I have included a note that says that this is the output when printing
set elements (where the key and key length are not available).

Applied, thanks.
