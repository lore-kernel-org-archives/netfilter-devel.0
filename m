From: "lucien chaubert" <lucien.chaubert@quaxio.com>
Subject: Chain name in ip_table.c
Date: Mon, 4 Aug 2008 15:51:04 +0200
Message-ID: <2446d4600808040651w38e05c17jf897d9cf104ea672@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:3668 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYHDNvH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:51:07 -0400
Received: by gv-out-0910.google.com with SMTP id e6so18472gvc.37
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2008 06:51:05 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dears,

I new in netfilter and I'm trying to add log when a rule is added.

Effectively, when a rule is added with iptables (frontend) nothing
advertise the admin that a rule is added.

I work now in ip_tables.c in function __do_replace where the new tbale
is replaced.

I can get the protocol, the IP, the target and the table name.

But I can't get the chain name (INPUT, OUTPUT,...).
I try to get it with :

int target_num;
// new and old table
struct ipt_entry * new_ipt_entry =3D (struct ipt_entry *)
(newinfo->entries[raw_smp_processor_id()]);
struct ipt_entry * old_ipt_entry =3D (struct ipt_entry *)
(oldinfo->entries [raw_smp_processor_id()]);
// for the target
struct ipt_entry_target *target =3D ipt_get_target(new_ipt_entry);

// for each rule
for (rule=3D0;rule< newinfo->number;
{
        printk("Proto: %i  IP src: %x IP dst: %x Flag: %i Flag inv: %i
iniface %s  outiface %s   \n",
            new_ipt_entry->ip.proto, new_ipt_entry->ip.src.s_addr,
new_ipt_entry->ip.dst.s_addr, 	new_ipt_entry->ip.flags,
new_ipt_entry->ip.invflags, new_ipt_entry->ip.iniface,
	new_ipt_entry->ip.outiface);

            target =3D ipt_get_target(new_ipt_entry);

            // to display the target
            target_num =3D *(int *)target->data;
            printk("Target %i\n",target_num);

            // ??????? to display the chain name ???????????
            printk("Name: %s \n",target->u.kernel.target->name);

            // to go to the next rule
            new_ipt_entry =3D (struct ipt_entry*)
(((char*)new_ipt_entry)+new_ipt_entry->next_offset);
            old_ipt_entry =3D (struct ipt_entry*)
(((char*)old_ipt_entry)+old_ipt_entry->next_offset);
}

But I can only get =AB Error=BB at the last rule for the chain name.

Someone know where and how can I get this information (maybe I'm not
working in the good function)?

I hope I don't disturb you.

Thank you very much for your help.

Lucien
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
