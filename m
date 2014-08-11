From: Yanchuan Nian <ycnian@gmail.com>
Subject: Bug: Some anonymous sets aren't displayed correctly
Date: Mon, 11 Aug 2014 15:51:12 +0800
Message-ID: <1407743472-9165-1-git-send-email-ycnian@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37235 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaHKHsp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:48:45 -0400
Received: by mail-pa0-f47.google.com with SMTP id kx10so10688049pab.34
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Aug 2014 00:48:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some anonymous sets aren't displayed correctly, look at the result of
following commands.

nft> add rule ip filter input meta length {1000, 2000} counter
nft> add rule ip filter input meta iifname {eth0, eth1} counter
nft> list table ip filter
table ip filter {
        chain input {
                 type filter hook input priority 0;
                 meta length { 3892510720, 3490119680} counter packets 0 bytes 0
                 iifname { "", ""} counter packets 0 bytes 0
        }
}

This is because the data types used in meta length and meta iifname are
integer and string, whose byteorders are BYTEORDER_INVALID.
In netlink_delinearize_setelem, the value stored in expr cannot be converted
to host byte order, so the value cannot be displayed correctly. In order to fix
this bug, just set the byteorder of integer_type and string_type to
BYTEORDER_HOST_ENDIAN.

But I have some questions. As anonymous sets can be used with meta ifname,
should we add a new datatype as follows, so normal sets can be created and then
used by meta ifname?

static const struct datatype ifname_type = {
        .type           = TYPE_IFNAME,
        .name           = "ifname",
        .desc           = "interface name",
        .byteorder      = BYTEORDER_HOST_ENDIAN,
        .size           = IFNAMSIZ * BITS_PER_BYTE,
        .basetype       = &string_type,
};

Besides meta ifname, many other selectors appear to be suffering from the same
problem, such as: meta length, tcp window, {icmp, udp, tcp, ip, ...} checksum,
{ah, icmp, tcp, ...} sequence. Should we add new datatypes for them? Who
is interested in packets with exact checksum or sequence? I wonder.

So, is it a better way to forbid such anonymous sets completely? We can do some
work in implicit_set_declaration. If set->keylen != set->keytype->size, return
with a error message.

Pablo, what's your opinion?

