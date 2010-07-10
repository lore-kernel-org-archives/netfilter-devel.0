From: Pete Kay <petedao@gmail.com>
Subject: Problem with Too many levels of symbolic links
Date: Sat, 10 Jul 2010 23:15:42 +0800
Message-ID: <AANLkTinBc_6zISFzIpJU0WoWh21D3t37YfdZ9bJA6i2F@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63026 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab0GJPPn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Jul 2010 11:15:43 -0400
Received: by pzk26 with SMTP id 26so724984pzk.19
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Jul 2010 08:15:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have written a very simple program to add iptables rule, but I am
kept getting " Too many levels of symbolic links" .

Does anyone know what is wrong?


 int ret = 0;
  iptc_handle_t   h = iptc_init("nat");

  struct ipt_entry_match *match;
  struct ipt_udp *match_udp;
  struct ipt_entry_target *target;
  char callee_inhibitor_buf[IPTC_FULL_SIZE];
  struct ipt_entry *entry = (struct ipt_entry *) callee_inhibitor_buf;


    memset(entry, 0, IPTC_FULL_SIZE);
    entry->ip.proto = IPPROTO_UDP;
    entry->ip.src.s_addr = inet_addr("192.168.3.2");

    memset(&entry->ip.smsk, 255, sizeof(struct in_addr));
 entry ->ip.smsk.s_addr =   0xffffffff;
   entry->ip.dst.s_addr = inet_addr("200.168.3.3");
        entry ->ip.dmsk.s_addr  = 0xffffffff;
    entry->target_offset = IPTC_ENTRY_SIZE + IPTC_MATCH_SIZE;
    entry->next_offset = IPTC_FULL_SIZE;
    match = (struct ipt_entry_match *) entry->elems;
  //    match = (struct ipt_entry_match *)entry->elems;
        match->u.user.match_size = IPTC_MATCH_SIZE;
    strcpy(match->u.user.name, "udp");
    match_udp = (struct ipt_udp*) &match->data;
    match_udp->spts[0] = 5060;match_udp->spts[1] = 5060;
    match_udp->dpts[0] = 5070;match_udp->dpts[1] = 5070;
    target = (struct ipt_entry_target*) (match + IPTC_MATCH_SIZE);

    target->u.user.target_size = IPTC_TARGET_SIZE;
    strcpy(target->u.user.name, "ACCEPT");
    ret = iptc_append_entry ("PREROUTING", entry, h);
        if (!ret) {
                printf("append : %s\n", iptc_strerror(errno));
        }
        ret =iptc_commit(h);
        printf("commit =[%i]\n", ret);
        if (!ret) {
                printf("commit: %s\n", iptc_strerror(errno));
        }
