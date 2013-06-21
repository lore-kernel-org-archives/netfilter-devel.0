From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] test: add testbench for XML
Date: Sat, 22 Jun 2013 00:44:09 +0200
Message-ID: <CAOkSjBiaN=GR7emE1W5-GjB3yDQfDNKtbqzj_eT+gv0sJZgkLA@mail.gmail.com>
References: <20130618205857.1600.52812.stgit@nfdev.cica.es> <20130620190234.GA13710@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:63051 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423646Ab3FUWob convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 18:44:31 -0400
Received: by mail-lb0-f170.google.com with SMTP id t13so74847lbd.29
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2013 15:44:30 -0700 (PDT)
In-Reply-To: <20130620190234.GA13710@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I already have a patch series to address yours requests.
But, please, I need some more details in the next issues:

2013/6/20 Pablo Neira Ayuso <pablo@netfilter.org>:
>> diff --git a/test/xmlfiles/rule_exthdr.xml b/test/xmlfiles/rule_exth=
dr.xml
>> new file mode 100644
>> index 0000000..0abeb3c
>> --- /dev/null
>> +++ b/test/xmlfiles/rule_exthdr.xml
>> @@ -0,0 +1,12 @@
>> +<rule family=3D"2" table=3D"filter" chain=3D"INPUT" handle=3D"100" =
version=3D"0">
>> +  <rule_flags>0</rule_flags>
>> +  <flags>127</flags>
>> +  <compat_flags>0</compat_flags>
>> +  <compat_proto>0</compat_proto>
>> +  <expr type=3D"exthdr">
>> +    <dreg>123</dreg>
>
> fix.
>
>> +    <type>15</type>
>
> Possibilities are defined by: nft_exthdr_attributes

I did not understand this.
In include/uapi/linux/netfilter/nf_tables.h I have:

enum nft_exthdr_attributes {
NFTA_EXTHDR_UNSPEC,
NFTA_EXTHDR_DREG,
NFTA_EXTHDR_TYPE,
NFTA_EXTHDR_OFFSET,
NFTA_EXTHDR_LEN,
__NFTA_EXTHDR_MAX
};

What should I do with this?

>> diff --git a/test/xmlfiles/rule_immediate.xml b/test/xmlfiles/rule_i=
mmediate.xml
>> new file mode 100644
>> index 0000000..a566ca5
>> --- /dev/null
>> +++ b/test/xmlfiles/rule_immediate.xml
>> @@ -0,0 +1,31 @@
>> +<rule family=3D"2" table=3D"filter" chain=3D"INPUT" handle=3D"100" =
version=3D"0">
>> +  <rule_flags>0</rule_flags>
>> +  <flags>127</flags>
>> +  <compat_flags>0</compat_flags>
>> +  <compat_proto>0</compat_proto>
>> +  <expr type=3D"immediate">
>> +    <dreg>1</dreg>
>> +    <immdata>
>> +      <data_reg type=3D"value">
>> +        <len>1</len>
>> +     <data0>0xaabbccdd</data0>
>
> Lenghs says 1 byte, but I can see way more stuff there.

mmmm,

the XML node 'len' means how many '<data>' nodes we have.

Then, the actual length of the data is somehow hard-coded in the lib
and is calculated this way:
data_reg.len =3D xml_node_len_value * sizeof(data_reg.val[0])

Maybe is not fully implemented yet, but I already have an incoming
patch to address this.

>> diff --git a/test/xmlfiles/rule_log.xml b/test/xmlfiles/rule_log.xml
>> new file mode 100644
>> index 0000000..5471fee
>> --- /dev/null
>> +++ b/test/xmlfiles/rule_log.xml
>> @@ -0,0 +1,12 @@
>> +<rule family=3D"2" table=3D"filter" chain=3D"INPUT" handle=3D"100" =
version=3D"0">
>> +  <rule_flags>0</rule_flags>
>> +  <flags>127</flags>
>> +  <compat_flags>0</compat_flags>
>> +  <compat_proto>0</compat_proto>
>> +  <expr type=3D"log">
>> +    <group>123123121</group>
>
> possible groups are 0-65535.

Maybe I should also change the group data type to uint16_t.

>> diff --git a/test/xmlfiles/rule_nat.xml b/test/xmlfiles/rule_nat.xml
>> new file mode 100644
>> index 0000000..868be50
>> --- /dev/null
>> +++ b/test/xmlfiles/rule_nat.xml
>> @@ -0,0 +1,22 @@
>> +<rule family=3D"2" table=3D"filter" chain=3D"INPUT" handle=3D"100" =
version=3D"0">
>> +  <rule_flags>0</rule_flags>
>> +  <flags>127</flags>
>> +  <compat_flags>0</compat_flags>
>> +  <compat_proto>0</compat_proto>
>> +  <expr type=3D"nat">
>> +    <sreg_addr_min>1</sreg_addr_min>
>> +    <sreg_addr_max>1</sreg_addr_max>
>
> These above are IPv4 / IPv6 addresses. Should be printable ini
> human readable format, you probably use inet_ntop for output and
> inet_pton for input.
>
>> +    <sreg_proto_min>1</sreg_proto_min>
>> +    <sreg_proto_max>1</sreg_proto_max>
>
> max here is 2^16 as they are port numbers.
>
>> +    <family>AF_INET6</family>
>
> would be good to replace this by ip6.
>
>> +    <type>NFT_NAT_DNAT</type>
>
> and this by dnat.
>
>> +  </expr>
>> +  <expr type=3D"nat">
>
> The ipv4 part is asking for a new file, add rule_nat-ipv4.xml and
> rule_nat-ipv6.xml
>

I will do it. But I think that from the parsing point of view, is the
same having two nat expr in one <rule> file.

>> diff --git a/test/xmlfiles/table2.xml b/test/xmlfiles/table2.xml
>> new file mode 100644
>> index 0000000..de8e570
>> --- /dev/null
>> +++ b/test/xmlfiles/table2.xml
>> @@ -0,0 +1,6 @@
>> +<table name=3D"nat" version=3D"0">
>> +     <properties>
>> +             <family>10</family>
>> +             <table_flags>123</table_flags>
>
> The only table flag is defined by enum nft_table_flags.
>

What if we have some kind of general validation functions?

- The xml_parse() will just translate the XML to an object, with no
additional validations.
- The validate() will take care of values being 'real'.

Example:

int nft_table_validate(struct nft_table t)
{
  /* validate family or return -1 */
  /* validate table_flags or return -1*/
  /* validate...maybe name length or return -1*/
}
EXPORT_SYMBOL(nft_table_validate);

I think this may be useful both for userspace programs (who used
_set() and _unset() funcs) and the JSON stuff.
And it will not require so many lines of code.
At the end, from inside the xml_parse() function we can call
_validate() and only consider the parsing done if the object
validates.
Its a good idea? Should I work on this?

Regards.

--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
