From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 00/13] ipset patches for nf-next
Date: Sat, 27 Apr 2013 13:54:50 +0100
Message-ID: <517BCA9A.3080602@googlemail.com>
References: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57949 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3D0MzD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 08:55:03 -0400
Received: by mail-wi0-f181.google.com with SMTP id c10so1463294wiw.8
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2013 05:55:01 -0700 (PDT)
Received: from [10.68.68.173] (cpc2-gill1-0-0-cust218.basl.cable.virginmedia.com. [82.34.56.219])
        by mx.google.com with ESMTPSA id fp2sm9052376wib.7.2013.04.27.05.54.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 27 Apr 2013 05:55:00 -0700 (PDT)
In-Reply-To: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Jozsef Kadlecsik wrote:
> Hi Pablo,
>
> Please consider applying the next patches against your nf-next tree.
>
> The patches introduce the new extensions infrastructure in ipset and
> add packet/byte counters as a new extension besides timeouts. The set
> match is extended by the functionality to match the counters too.
>
> Best regards,
> Jozsef
>   
Jozsef, are these features already supported in userspace or are you 
going to release a separate version?

