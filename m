From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add nfq_snprintf_xml() to output a packet in XML format
Date: Thu, 27 May 2010 13:50:23 +0200
Message-ID: <4BFE5C7F.2030400@netfilter.org>
References: <20100526123953.6016.65536.stgit@decadence> <alpine.LSU.2.01.1005261740270.1686@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50410 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab0E0Luc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 07:50:32 -0400
In-Reply-To: <alpine.LSU.2.01.1005261740270.1686@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-05-26 14:39, Pablo Neira Ayuso wrote:
> 
>> This patch adds a new function to output the packet in XML format.
> 
>> +int nfq_snprintf_xml(char *buf, int len, struct nfq_data *tb, int flags)
>> +{
>> +	struct nfqnl_msg_packet_hdr *ph;
>> +	struct nfqnl_msg_packet_hw *hwph;
>> +	u_int32_t mark, ifi;
>> +	int size, offset = 0, ret;
>> +	char *data;
>> +
>> +	size = snprintf(buf + offset, len, "<pkt>");
>> +	SNPRINTF_FAILURE(size, len, offset);
>> +
>> +	ph = nfq_get_msg_packet_hdr(tb);
>> +	if (ph) {
>> +		size = snprintf(buf + offset, len,
>> +				"<hook>%u</hook><id>%u</id>",
>> +				ph->hook, ntohl(ph->packet_id));
>> +		SNPRINTF_FAILURE(size, len, offset);
> 
> Couldn't libxml be used to generate the XML?

Adding such a dependency is overkill. One of the good things of these
libraries is that they are small and they have small dependencies.

>> +	ret = nfq_get_payload(tb, &data);
>> +	if (ret >= 0 && (flags & NFQ_XML_PAYLOAD)) {
>> +		int i;
>> +
>> +		size = snprintf(buf + offset, len, "<payload>");
>> +		SNPRINTF_FAILURE(size, len, offset);
>> +
>> +		for (i=0; i<ret; i++) {
>> +			size = snprintf(buf + offset, len, "x%02x",
> 
> What's the leading x for? It seems to add no value.

We can remove that or include a backslash before the 'x'.
