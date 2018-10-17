From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: netfilter request for -stable 4.9.x inclusion
Date: Wed, 17 Oct 2018 18:34:22 +0200
Message-ID: <20181017163422.bqp4ydpj5ndhhrrd@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Laura Garcia <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Greg,

Could you enqueue the following patch for -stable 4.9.x?

commit ab6dd1beac7be3c17f8bf3d38bdf29ecb7293f1e
Author: Xin Long <lucien.xin@gmail.com>
Date:   Thu Aug 10 10:22:24 2017 +0800

    netfilter: check for seqadj ext existence before adding it in nf_nat_setup_info

Cc'ing Laura, combining SNAT+DNAT+ftp helper is currently broken with
4.9.x. The patch above cures the issues.

Thanks.
