From: Rami Rosen <roszenrami@gmail.com>
Subject: Re: [conntrack-tools PATCH 4/4] doc/manual/conntrack-tools: include
 some bits about init systems
Date: Wed, 31 Aug 2016 00:11:19 +0300
Message-ID: <CAKoUArkMKgmWMJWfBFwHufFFkp9kXRuxrvVA7toy5eMQAEo5yw@mail.gmail.com>
References: <147255963490.17411.649527820452381341.stgit@nfdev2.cica.es> <147255965086.17411.4934850892465559614.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35866 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751998AbcH3VLV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 17:11:21 -0400
Received: by mail-lf0-f65.google.com with SMTP id 33so1492892lfw.3
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 14:11:20 -0700 (PDT)
In-Reply-To: <147255965086.17411.4934850892465559614.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, Arturo,
Several light fixes/suggestions are following:


should be: of youe choice
> +       distro of your choose does this, as there are some interesting things
> +       to take into account.
> +  </para>


I would suggest: fallback (I think it is more techncally common, maybe
I am wrong)
> +       sync each node after a failback operation, so the new node

Should be: these  operations
> +       time. This operations requires the main conntrackd daemon to open the
> +       UNIX socket to receive the order from the

I would suggest: after fallback (Again, I think it is more techncally
common, maybe I am wrong)
> +       launched). Otherwise, you may end with a new node (after failback)

should be: then you can
> +       (using <emphasis>--enable-systemd</emphasis>), the you can
> +
> +  <para>
> +       Using systemd and conntrackd with libsystemd support and a service file
I would suggest: of its readiness
> +       of Type=notify means that conntrackd will notify of his readiness to

Keep on the good work!

Rami Rosen
