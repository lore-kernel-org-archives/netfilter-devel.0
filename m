From: Patrick McHardy <kaber@trash.net>
Subject: Re: R:Re: Questions about early_drop()
Date: Thu, 05 Nov 2009 13:23:56 +0100
Message-ID: <4AF2C3DC.7070200@trash.net>
References: <0016e6d7ea70951fbb04779150de@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pesce.luca@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33105 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZKEMXx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 07:23:53 -0500
In-Reply-To: <0016e6d7ea70951fbb04779150de@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

pesce.luca@gmail.com wrote:
> Hi Patrick,
> thanks for the explanation. The only thing I do not understand is:
> 
>> It does greatly improve robustness under DoS since with jhash() and a
>> properly sized
>> hash table there's likely only a single entry per bucket.
> 
> I understand that this comes from hash tables theory, but I don't get
> it... When conntrack_core module is loaded, the maximum number of
> conntrack entries is calculated as (hashsize * 8), so when early_drop()
> kicks in, the table is full and is containing (hashsize*8) entries...
> how is it possible that in that situation every bucket contains just one
> entry? Shouldn't it contain about 8 entries, as a mean value?

The default is not properly sized, its a trade-off between memory
use and performance. A good size would be 2 * max_entries since
each conntrack is hashed twice.

