From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: Unable to post - Ulogd / NFCT - Request for changes
Date: Wed, 18 Jul 2012 08:10:52 -0700
Message-ID: <CAAJpzgYYNbET-M07dKN6tEa7qpL3z0+6Tm=mRewnsoZue_Yddw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45067 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2GRPLO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:11:14 -0400
Received: by ghrr11 with SMTP id r11so1657505ghr.19
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jul 2012 08:11:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Currently NFCT supports polling mode, but polling mode only propagates
the message to output plugin during DESTROY event.
This is a problem for long living connections, since I want to know
the amount of data transfer before the destroy event.
After getting a quick walk through on NFCT plugin code, It seems I
have to change the do_purge method, which is called in a regular time
interval.

I came with the following updates in the code (I added the else block only).


static int do_purge(void *data1, void *data2)
{
        int ret;
        struct ulogd_pluginstance *upi = data1;
        struct ct_timestamp *ts = data2;
        struct nfct_pluginstance *cpi =
                                (struct nfct_pluginstance *) upi->private;

        ulogd_log(ULOGD_NOTICE,"Inside do_purge method\n");

        /* if it is not in kernel anymore, purge it */
        ret = nfct_query(cpi->pgh, NFCT_Q_GET, ts->ct);
        if (ret == -1 && errno == ENOENT) {
                do_propagate_ct(upi, ts->ct, NFCT_T_DESTROY, ts);
                hashtable_del(cpi->ct_active, &ts->hashnode);
                nfct_destroy(ts->ct);
                free(ts);
        }
        else // Added code
        {
                do_propagate_ct(upi, ts->ct,NFCT_T_UPDATE,ts);
        }

        return 0;
}

The else part propagates a flow eventhough there were no updates
happened to the flow. Could you help somone here, I would like to
propagate about the updates of a connection, if there was a change
happened to the long living connection. Is this correct approach?

My intuition, I have to call nfct_cmp method by passing the local hash
table connection, and the available connection in the kernel. If they
are same, then there were no updates happened to the connection,
otherwise I will propagate the details of the particular connection.

Thanks & Regards,
