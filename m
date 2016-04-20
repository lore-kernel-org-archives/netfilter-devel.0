From: Bogdan Harjoc <harjoc@gmail.com>
Subject: Minor issue in libnetfilter_queue.c - nfq_set_queue_maxlen
Date: Wed, 20 Apr 2016 18:36:34 +0300
Message-ID: <CAF4+tmr1mOH4eRA8sW74GocCR9kd2i3iaPWtCOgq_nG03oLzTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38512 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbcDTPgg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Apr 2016 11:36:36 -0400
Received: by mail-wm0-f41.google.com with SMTP id u206so88120243wme.1
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2016 08:36:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nfq_set_queue_maxlen() allocates a struct nfqnl_msg_config_params
(int32 + int8) and only stores a queue_maxlen which is an int32. It
should probably be just

+NFA_LENGTH(sizeof(uint32_t))

Probably not an issue since the buffer is just larger than it needs to be.
