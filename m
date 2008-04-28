From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/7] Add label option to NFLOG input plugin.
Date: Mon, 28 Apr 2008 15:44:16 +0200
Message-ID: <4815D4B0.6040703@netfilter.org>
References: <4805E566.7010902@netfilter.org> <1208352161448-git-send-email-eric@inl.fr> <48142AE7.5020701@netfilter.org> <20080427084403.GB9479@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58391 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932088AbYD1Ngb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:36:31 -0400
In-Reply-To: <20080427084403.GB9479@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Sunday, 2008 April 27 at  9:27:35 +0200, Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>>> @@ -78,6 +78,13 @@ static struct config_keyset libulog_kset = {
>>>  			.options = CONFIG_OPT_NONE,
>>>  			.u.value = 0,
>>>  		},
>>> +		{
>>> +			.key	 = "label",
>>> +			.type	 = CONFIG_TYPE_INT,
>>> +			.options = CONFIG_OPT_NONE,
>>> +			.u.value = 0,
>>> +		},
>>> +
>>>  	}
>>>  };
>> Wouldn't it better if we use a string instead of an integer? Thus, this
>> will really work as labeler.
> 
> We already have the log prefix for a string label usage. I think it will
> brought confusion to have both a string log prefix and a string label.
> Furthermore, the goal of the label is to be able to classify packets and
> an integer will be faster (in the database), stricter (to avoid
> confusion) and smaller (to store) than a string.

OK, then I'd prefer if we change the name again to "numberic_label". 
Sorry for the annoyance.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
